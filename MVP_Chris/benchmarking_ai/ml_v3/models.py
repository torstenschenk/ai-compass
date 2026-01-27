
import pandas as pd
import numpy as np
import pickle
import json
import os
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import NearestNeighbors
from scipy.stats import zscore

class ClusterEngine:
    def __init__(self, n_clusters=5):
        self.n_clusters = n_clusters
        self.model = None
        self.scaler = StandardScaler()
        self.pca = PCA(n_components=2)
        self.profiles = None 
        self.labels_map = {}

    def fit(self, data, cluster_profiles=None):
        """
        Args:
            data (pd.DataFrame): Training Dimension Matrix
            cluster_profiles (pd.DataFrame): DB Metadata for naming
        """
        self.profiles = cluster_profiles
        X = self.scaler.fit_transform(data.fillna(0))
        
        self.model = KMeans(n_clusters=self.n_clusters, random_state=42)
        self.model.fit(X)
        self.pca.fit(X)
        
        # Build Label Map immediately after training
        self._build_label_map(data, self.model.labels_)

    def _build_label_map(self, data, labels):
        """Internal method to map cluster IDs to semantic names based on rank."""
        df = data.copy()
        df['Cluster'] = labels
        means = df.groupby('Cluster').mean().mean(axis=1) # Average score per cluster
        sorted_clusters = means.sort_values().index.tolist()
        
        self.labels_map = {}
        # Strictly map to the 5 established Hybrid ML v2 profiles
        # Fallback names corresponding to ranks 1-5
        hybrid_names = [
            "1 - The Traditionalist",
            "2 - The Experimental Explorer", 
            "3 - The Structured Builder",
            "4 - The Operational Scaler",
            "5 - The AI-Driven Leader"
        ]
        
        if self.profiles is not None and not self.profiles.empty:
             sorted_profiles = self.profiles.sort_values('cluster_id').to_dict('records')
             for rank_idx, cluster_idx in enumerate(sorted_clusters):
                 # Ensure we don't go out of bounds if n_clusters > n_profiles (should be fixed at 5)
                 p_idx = min(rank_idx, len(sorted_profiles)-1)
                 p = sorted_profiles[p_idx]
                 self.labels_map[cluster_idx] = f"{p['cluster_id']} - {p['cluster_name']}"
        else:
             # Use the strict fallback list
             for rank_idx, cluster_idx in enumerate(sorted_clusters):
                 name = hybrid_names[min(rank_idx, 4)]
                 self.labels_map[cluster_idx] = name

    def predict(self, company_df):
        """
        Predicts cluster for a single company or batch. 
        Returns (Cluster_ID, Cluster_Name, PCA_X, PCA_Y)
        """
        X_new = self.scaler.transform(company_df.fillna(0))
        cluster_ids = self.model.predict(X_new)
        coords = self.pca.transform(X_new)
        
        names = [self.labels_map.get(c, f"Cluster {c}") for c in cluster_ids]
        
        return cluster_ids, names, coords

    def save_model(self, path_prefix):
        """Saves model artifacts to disk."""
        with open(f"{path_prefix}_kmeans.pkl", 'wb') as f:
            pickle.dump(self.model, f)
        with open(f"{path_prefix}_scaler.pkl", 'wb') as f:
            pickle.dump(self.scaler, f)
        with open(f"{path_prefix}_pca.pkl", 'wb') as f:
            pickle.dump(self.pca, f)
        with open(f"{path_prefix}_labels.json", 'w') as f:
            json.dump(self.labels_map, f)

    def load_model(self, path_prefix):
        """Loads model artifacts from disk."""
        with open(f"{path_prefix}_kmeans.pkl", 'rb') as f:
            self.model = pickle.load(f)
        with open(f"{path_prefix}_scaler.pkl", 'rb') as f:
            self.scaler = pickle.load(f)
        with open(f"{path_prefix}_pca.pkl", 'rb') as f:
            self.pca = pickle.load(f)
        with open(f"{path_prefix}_labels.json", 'r') as f:
            # Json keys are strings, convert back to int
            loaded_map = json.load(f)
            self.labels_map = {int(k): v for k, v in loaded_map.items()}

class AnomalyDetector:
    def __init__(self):
        self.stats = {} # Mean/Std for each gap pair
        self.risk_pairs = [
            ('Tech Infrastructure', 'People & Culture'),
            ('Tech Infrastructure', 'Strategy & Business Vision'),
            ('Data Readiness & Literacy', 'Use Cases & Business Value'),
            ('Processes & Scaling', 'Governance & Compliance')
        ]

    def fit(self, data):
        """Calculates population statistics for risk pairs."""
        df = data.copy().fillna(0)
        self.stats = {}
        
        for p1, p2 in self.risk_pairs:
            if p1 in df.columns and p2 in df.columns:
                gap_vals = df[p1] - df[p2]
                self.stats[f"{p1}|{p2}"] = {
                    'mean': float(gap_vals.mean()),
                    'std': float(gap_vals.std())
                }

    def detect(self, company_series):
        """
        Input: pd.Series of dimension scores for ONE company.
        Output: List of anomaly strings.
        """
        findings = []
        for pair_key, stat in self.stats.items():
            p1, p2 = pair_key.split('|')
            if p1 not in company_series or p2 not in company_series:
                continue
                
            val1 = company_series[p1]
            val2 = company_series[p2]
            gap = val1 - val2
            
            # Calculate Z-Score against population
            z = (gap - stat['mean']) / (stat['std'] + 1e-9) # Avoid div/0
            
            if abs(z) > 1.5:
                if gap > 0: # p1 significantly > p2
                    findings.append(f"Critical Imbalance: {p1} ({val1:.1f}) is ahead of {p2} ({val2:.1f}). (Z={z:.1f})")
                else: # p2 significantly > p1
                    findings.append(f"Bottleneck: {p2} ({val2:.1f}) is ready to scale but held back by {p1} ({val1:.1f}). (Z={z:.1f})")
        return findings

    def save_model(self, path):
        """Saves stats to JSON."""
        with open(path, 'w') as f:
            json.dump(self.stats, f)

    def load_model(self, path):
        with open(path, 'r') as f:
            self.stats = json.load(f)

class Recommender:
    def __init__(self):
        self.knn = None
        self.scaler = StandardScaler()
        self.X_train = None # We need to keep the training data for finding neighbors
        self.total_scores = None

    def fit(self, data):
        """
        Args:
            data (pd.DataFrame): Dimension Matrix
        """
        df = data.copy().fillna(0)
        df['total_maturity'] = df.mean(axis=1) # Calculate total score
        
        self.X_train = df.drop(columns=['total_maturity'])
        self.total_scores = df['total_maturity']
        
        X_scaled = self.scaler.fit_transform(self.X_train)
        # Increase k to ensure we find "Next Level" peers who might be further away
        n = min(len(df), 50) 
        self.knn = NearestNeighbors(n_neighbors=n, metric='euclidean')
        self.knn.fit(X_scaled)

    def recommend(self, company_series):
        """
        Input: pd.Series of dimension scores.
        Output: (Action, Rationale)
        """
        target_score = company_series.mean()
        
        # 1. Prepare input
        input_vector = self.scaler.transform(company_series.values.reshape(1, -1))
        
        # 2. Find Neighbors (Top 50)
        distances, indices = self.knn.kneighbors(input_vector)
        neighbor_indices = indices[0]
        
        # Look up neighbor scores
        neighbor_feats = self.X_train.iloc[neighbor_indices]
        neighbor_totals = self.total_scores.iloc[neighbor_indices]
        
        # 3. STRATEGY A: The "Next Level" Cohort (15% - 30% Better)
        # We want peers who are significantly ahead to serve as valid benchmarks
        lower_bound = target_score * 1.15
        upper_bound = target_score * 1.30
        
        next_level_peers = neighbor_feats[
            (neighbor_totals >= lower_bound) & 
            (neighbor_totals <= upper_bound)
        ]
        
        cohort_name = "peers 15-30% ahead of you"
        
        # 4. STRATEGY B: Any Better Peer (Fallback)
        if next_level_peers.empty:
            next_level_peers = neighbor_feats[neighbor_totals > target_score + 0.1]
            cohort_name = "more mature peers"
            
        # 5. Recommendation Logic
        if not next_level_peers.empty:
            peer_avg = next_level_peers.mean()
            gaps = peer_avg - company_series
            
            if gaps.max() > 0:
                rec_dim = gaps.idxmax()
                gap_val = gaps.max()
                
                # Calculate percentage ahead
                user_val = company_series[rec_dim]
                if user_val > 0:
                    pct_diff = (gap_val / user_val) * 100
                else:
                    pct_diff = 0 # Should not happen on 1-5 scale
                    
                return rec_dim, f"Your peers are {pct_diff:.0f}% ahead of you in this area."

        # 6. STRATEGY C: Weakest Link (Fallback for Top Performers or No Gaps)
        # Just find the absolute lowest score
        weakest_dim = company_series.idxmin()
        weakest_val = company_series.min()
        
        # If perfect score?
        if weakest_val >= 5.0:
             return "Maintain Leadership", "You have achieved maximum maturity across all dimensions."
             
        return weakest_dim, f"This is your weakest point (Score: {weakest_val:.1f}). Shoring this up will balance your profile."

    def save_model(self, path_prefix):
        # We need to pickle the whole object or the components
        # Simpler to pickle the components needed for inference
        state = {
            'X_train': self.X_train,
            'total_scores': self.total_scores,
            'knn': self.knn,
            'scaler': self.scaler
        }
        with open(f"{path_prefix}_recommender.pkl", 'wb') as f:
            pickle.dump(state, f)

    def load_model(self, path_prefix):
        with open(f"{path_prefix}_recommender.pkl", 'rb') as f:
            state = pickle.load(f)
            self.X_train = state['X_train']
            self.total_scores = state['total_scores']
            self.knn = state['knn']
            self.scaler = state['scaler']
