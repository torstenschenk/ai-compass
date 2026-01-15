
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
    def __init__(self, dimension_matrix, n_clusters=3):
        self.dm = dimension_matrix.fillna(0)
        self.model = KMeans(n_clusters=n_clusters, random_state=42)
        self.scaler = StandardScaler()
        self.pca = PCA(n_components=2)
        self.labels = None
        self.pca_coords = None

    def train(self):
        """Trains KMeans and PCA."""
        X = self.scaler.fit_transform(self.dm)
        self.model.fit(X)
        self.labels = self.model.labels_
        
        # PCA for visualization
        self.pca_coords = self.pca.fit_transform(X)
        
        return self.labels

    def get_results_df(self):
        """Returns DataFrame with original data + Cluster + PCA x/y"""
        res = self.dm.copy()
        res['Cluster'] = self.labels
        res['PCA_X'] = self.pca_coords[:,0]
        res['PCA_Y'] = self.pca_coords[:,1]
        return res

    def predict(self, new_data_df):
        """Predicts cluster for new data."""
        X_new = self.scaler.transform(new_data_df.fillna(0))
        return self.model.predict(X_new)
