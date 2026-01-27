
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from scipy import stats

class BenchmarkEngine:
    def __init__(self, dimension_matrix, metadata):
        """
        Args:
            dimension_matrix (pd.DataFrame): Index=company_id, Cols=dimensions
            metadata (pd.DataFrame): Index=company_id (implied), Cols=industry, size
        """
        self.dm = dimension_matrix
        self.meta = metadata
        # Ensure indices match
        # Check if metadata is already indexed by company_id
        if 'company_id' in self.meta.columns:
            self.combined = self.dm.join(self.meta.set_index('company_id'), how='inner')
        else:
            # metadata is already indexed
            self.combined = self.dm.join(self.meta, how='inner')

    def get_peer_group(self, industry=None, size=None):
        """Returns the subset of companies matching the criteria."""
        df = self.combined.copy()
        if industry:
            df = df[df['industry'] == industry]
        if size:
            df = df[df['number_of_employees'] == size]
        return df

    def calculate_percentile(self, company_id, dimension_col):
        """Calculates the percentile of a company within its peer group for a dimension."""
        # 1. Identify Company Metadata
        if company_id not in self.combined.index:
            return None
        
        comp_meta = self.combined.loc[company_id]
        industry = comp_meta['industry']
        size = comp_meta['number_of_employees']

        # 2. Get Peer Group
        peers = self.get_peer_group(industry, size)
        
        # 3. Get Scores
        company_score = self.combined.loc[company_id, dimension_col]
        peer_scores = peers[dimension_col].dropna()

        # 4. Calculate Percentile
        # percentileofscore returns rank 0-100
        p_score = stats.percentileofscore(peer_scores, company_score, kind='weak')
        return p_score

class ClusterEngine:
    def __init__(self, data, cluster_profiles=None, n_clusters=5):
        """
        Args:
            data (pd.DataFrame): The Dimension Matrix
            cluster_profiles (pd.DataFrame): Legacy archetype metadata
            n_clusters (int): Number of clusters to find
        """
        self.data = data.fillna(0) # Ensure data is filled for processing
        self.profiles = cluster_profiles
        self.model = None
        # WE DEFAULT TO 5 CLUSTERS BASED ON THE 5 DB PROFILES
        self.n_clusters = n_clusters
        self.scaler = StandardScaler() # Re-added based on train method
        self.pca = PCA(n_components=2) # Re-added based on train method
        self.labels = None # Re-added for consistency with get_results_df
        self.pca_coords = None

    def train(self):
        """Trains KMeans and PCA."""
        X = self.scaler.fit_transform(self.data) # Changed self.dm to self.data
        self.model = KMeans(n_clusters=self.n_clusters, random_state=42) # Initialize KMeans here
        self.model.fit(X)
        self.labels = self.model.labels_
        
        # PCA for visualization
        self.pca_coords = self.pca.fit_transform(X)
        
        return self.labels

    def get_results_df(self):
        """Returns DataFrame with original data + Cluster + PCA x/y"""
        res = self.data.copy()
        res['Cluster'] = self.labels
        res['PCA_X'] = self.pca_coords[:,0]
        res['PCA_Y'] = self.pca_coords[:,1]
        return res

    def get_cluster_labels(self):
        """
        Returns logical names for clusters based on their overall profile.
        Grounded Hybrid Logic: Maps the 5 ML clusters to the 5 DB archetypes 
        by ranking them based on their average dimension scores.
        This ensures all 5 strategic archetypes are represented.
        """
        results = self.get_results_df()
        dimension_cols = self.data.columns
        cluster_means = results.groupby('Cluster')[dimension_cols].mean()
        archetype_scores = cluster_means.mean(axis=1) # (n_clusters,)
        
        # Sort mathematical clusters by their average score (Lowest to Highest)
        sorted_clusters = archetype_scores.sort_values().index.tolist()
        
        labels = {}
        # If profiles exist, assign them in rank order to the clusters
        if self.profiles is not None and not self.profiles.empty:
             sorted_profiles_df = self.profiles.sort_values('cluster_id')
             sorted_p_list = sorted_profiles_df.to_dict('records')
             
             # Map Sorted Clusters (0-4 rank) to Sorted Profiles (0-4 id)
             for rank_idx, cluster_idx in enumerate(sorted_clusters):
                 # Get profile for this rank (handle case where n_clusters != n_profiles gracefully)
                 p_idx = min(rank_idx, len(sorted_p_list)-1)
                 profile = sorted_p_list[p_idx]
                 
                 p_name = profile.get('cluster_name', f"Cluster {cluster_idx+1}")
                 p_id = profile.get('cluster_id', rank_idx + 1)
                 
                 labels[cluster_idx] = f"{p_id} - {p_name}"
        else:
             # Fallback if no DB profiles
             names = ["The Traditionalist", "The Experimental Explorer", "The Structured Builder", "The Operational Scaler", "The AI-Driven Leader"]
             for rank_idx, cluster_idx in enumerate(sorted_clusters):
                 name = names[min(rank_idx, 4)]
                 labels[cluster_idx] = f"{rank_idx+1} - {name}"
            
        return labels

    def predict(self, new_data_df):
        """Predicts cluster for new data."""
        X_new = self.scaler.transform(new_data_df.fillna(0))
        return self.model.predict(X_new)
