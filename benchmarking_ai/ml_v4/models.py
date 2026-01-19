
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
from benchmarking_ai.ml_v4.utils import RISK_PAIRS, PHASE_MAPPING

class ClusterEngine:
    def __init__(self, n_clusters=5):
        self.n_clusters = n_clusters
        self.model = None
        self.scaler = StandardScaler()
        self.pca = PCA(n_components=2)
        self.profiles = None 
        self.labels_map = {}

    def fit(self, data, cluster_profiles=None):
        self.profiles = cluster_profiles
        X = self.scaler.fit_transform(data.fillna(0))
        
        self.model = KMeans(n_clusters=self.n_clusters, random_state=42)
        self.model.fit(X)
        self.pca.fit(X)
        
        self._build_label_map(data, self.model.labels_)

    def _build_label_map(self, data, labels):
        df = data.copy()
        df['Cluster'] = labels
        means = df.groupby('Cluster').mean().mean(axis=1)
        sorted_clusters = means.sort_values().index.tolist()
        
        self.labels_map = {}
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
                 p_idx = min(rank_idx, len(sorted_profiles)-1)
                 p = sorted_profiles[p_idx]
                 self.labels_map[cluster_idx] = f"{p['cluster_id']} - {p['cluster_name']}"
        else:
             for rank_idx, cluster_idx in enumerate(sorted_clusters):
                 name = hybrid_names[min(rank_idx, 4)]
                 self.labels_map[cluster_idx] = name

    def predict(self, company_df):
        X_new = self.scaler.transform(company_df.fillna(0))
        cluster_ids = self.model.predict(X_new)
        coords = self.pca.transform(X_new)
        
        names = [self.labels_map.get(c, f"Cluster {c}") for c in cluster_ids]
        
        return cluster_ids, names, coords

    def save_model(self, path_prefix):
        with open(f"{path_prefix}_kmeans.pkl", 'wb') as f:
            pickle.dump(self.model, f)
        with open(f"{path_prefix}_scaler.pkl", 'wb') as f:
            pickle.dump(self.scaler, f)
        with open(f"{path_prefix}_pca.pkl", 'wb') as f:
            pickle.dump(self.pca, f)
        with open(f"{path_prefix}_labels.json", 'w') as f:
            json.dump(self.labels_map, f)

    def load_model(self, path_prefix):
        with open(f"{path_prefix}_kmeans.pkl", 'rb') as f:
            self.model = pickle.load(f)
        with open(f"{path_prefix}_scaler.pkl", 'rb') as f:
            self.scaler = pickle.load(f)
        with open(f"{path_prefix}_pca.pkl", 'rb') as f:
            self.pca = pickle.load(f)
        with open(f"{path_prefix}_labels.json", 'r') as f:
            loaded_map = json.load(f)
            self.labels_map = {int(k): v for k, v in loaded_map.items()}

class StrategicGapAnalyzer:
    def __init__(self):
        self.pair_stats = {} # {pair_key: {mean, std}}
        self.dim_benchmarks = {} # {dim_name: mean_score}

    def fit(self, dim_data):
        """
        Learns population statistics for Risk Pairs and Benchmark Averages.
        dim_data: DataFrame (index=company_id, cols=Dimensions)
        """
        df = dim_data.copy().fillna(0)
        
        # 1. Benchmark Averages
        self.dim_benchmarks = df.mean().to_dict()
        
        # 2. Risk Pair Stats
        for p1, p2 in RISK_PAIRS:
            if p1 in df.columns and p2 in df.columns:
                gap_vals = (df[p1] - df[p2]).abs() # Magnitude of imbalance
                self.pair_stats[f"{p1}|{p2}"] = {
                    'mean': float(gap_vals.mean()),
                    'std': float(gap_vals.std())
                }

    def analyze(self, company_dim_series, company_question_df):
        """
        Analyzes a single company for Strategic Gaps.
        company_dim_series: Series of dimension scores.
        company_question_df: DataFrame with ('question_id', 'question_text', 'question_weight', 'score_1to5', 'question_type')
                             filtered for THIS company.
        """
        findings = []
        
        # --- Stage 1: Z-Score Anomalies ---
        for pair_key, stat in self.pair_stats.items():
            p1, p2 = pair_key.split('|')
            if p1 in company_dim_series and p2 in company_dim_series:
                gap = abs(company_dim_series[p1] - company_dim_series[p2])
                z = (gap - stat['mean']) / (stat['std'] + 1e-9)
                
                if z > 1.5:
                    findings.append({
                        "type": "Anomaly",
                        "title": f"Structural Imbalance: {p1} vs {p2}",
                        "score": z, # Use Z as severity
                        "context": f"Gap of {gap:.1f} points (Z={z:.1f}). Disconnect between {p1} ({company_dim_series[p1]:.1f}) and {p2} ({company_dim_series[p2]:.1f}).",
                        "source_dim": p1 if company_dim_series[p1] < company_dim_series[p2] else p2 # The lower one is the bottleneck usually, but anomaly is the relationship
                    })

        # --- Stage 2: Weighted Impact Gaps ---
        # Calculate Weighted Impact for ALL questions
        # Need: question_weight, score (converted to gap), type
        
        # We process the company_question_df to get high impact items
        # assuming company_question_df has 'question_weight', 'score_1to5', 'question_type', 'tactical_theme', 'dimension_name'
        
        impact_candidates = []
        if not company_question_df.empty:
            for _, row in company_question_df.iterrows():
                w = row.get('question_weight', 0)
                s = row.get('score_1to5', 1)
                q_type = row.get('question_type', 'Slider')
                
                if q_type == 'Checklist':
                    # If score is low (e.g. < 3), impact is high
                    impact = (w * 2) if s < 3.0 else 0
                else:
                    impact = w * (5.0 - s)
                
                if impact > 0:
                    impact_candidates.append({
                        "type": "Weakness",
                        "title": f"Critical Gap: {row.get('tactical_theme', 'Unknown Theme')}",
                        "score": impact,
                        "context": f"High Strategic Impact ({w}). Current Maturity: {s:.1f}. Theme: {row.get('tactical_theme', 'Unknown')}.",
                        "dimension_name": row.get('dimension_name'),
                        "tactical_theme": row.get('tactical_theme'),
                        "question_id": row.get('question_id')
                    })
        
        # Sort by Impact
        impact_candidates.sort(key=lambda x: x['score'], reverse=True)
        
        # Fill Findings (Target: 2)
        final_findings = findings[:2]
        
        if len(final_findings) < 2:
            needed = 2 - len(final_findings)
            # Filter candidates to avoid effective duplicates if needed, or just take top N
            # For simplicity, take top N not already covered (though anomaly covers dimension, this is specific)
            
            for item in impact_candidates:
                if len(final_findings) >= 2: break
                final_findings.append(item)
                
        return final_findings

    def synthesize_narrative(self, findings, company_scores):
        """
        Generates the consultant narrative.
        """
        header = "### 🎖️ AI-Compass Strategic Briefing"
        narrative = f"{header}\n\n"
        narrative += "Our analysis of your current AI maturity profile identifies two primary structural risks that require immediate executive attention.\n\n"
        
        if len(findings) > 0:
            f1 = findings[0]
            narrative += f"Firstly, we have identified a **{f1['title']}**. {f1['context']} This suggests that your current organizational trajectory may be creating 'Strategic Debt'—where technical capabilities outpace leadership alignment or vice versa.\n\n"
        
        if len(findings) > 1:
            f2 = findings[1]
            narrative += f"Secondly, the **{f2['title']}** indicates a critical gap in your foundational readiness. Currently, this maturity level ({f2['score']:.1f} impact score) acts as a significant bottleneck. Addressing this specific area will unlock higher ROI for your existing and future AI use cases.\n\n"
            
        narrative += "**Strategic Verdict**: Your profile shows high potential but is currently decoupled. Prioritizing these two areas over the next 3 months will transform your AI initiatives from experimental to scalable."
        return narrative

    def save_model(self, path_prefix):
        state = {'pair_stats': self.pair_stats, 'dim_benchmarks': self.dim_benchmarks}
        with open(f"{path_prefix}_gap_analyzer.pkl", 'wb') as f:
            pickle.dump(state, f)

    def load_model(self, path_prefix):
        with open(f"{path_prefix}_gap_analyzer.pkl", 'rb') as f:
            state = pickle.load(f)
            self.pair_stats = state['pair_stats']
            self.dim_benchmarks = state['dim_benchmarks']


class RoadmapGenerator:
    def __init__(self):
        self.knn = None
        self.scaler = StandardScaler()
        self.dim_data_train = None # Store for looking up peers
        self.question_data_train = None # Store for looking up peer question scores (aggregated)
        
    def fit(self, dim_data, question_data_agg):
        """
        dim_data: Index=Company, Cols=Dimensions
        question_data_agg: Index=Company, Cols=Questions (Scores) - Used to find peer strengths
        """
        self.dim_data_train = dim_data.copy().fillna(0)
        self.dim_data_train['total_maturity'] = self.dim_data_train.mean(axis=1)
        
        self.question_data_train = question_data_agg.copy().fillna(0)
        
        X = self.scaler.fit_transform(self.dim_data_train.drop(columns=['total_maturity']))
        
        self.knn = NearestNeighbors(n_neighbors=15, metric='cosine')
        self.knn.fit(X)

    def generate(self, company_id, company_dim_series, company_question_df, strategic_gaps):
        """
        Generates 3-Phase Roadmap.
        company_id: ID for reference (if needed for exclusionary logic, though we use vector lookup)
        company_dim_series: Current scores.
        company_question_df: Current question details (for "Growth Opps").
        strategic_gaps: Input from GapAnalyzer.
        """
        
        # 1. Identify Peers (Strategy A: 15-30% better)
        current_total = company_dim_series.mean()
        X_in = self.scaler.transform(company_dim_series.values.reshape(1, -1))
        
        distances, indices = self.knn.kneighbors(X_in)
        peer_indices = indices[0]
        
        peers = self.dim_data_train.iloc[peer_indices]
        
        # Filter for "Next Level"
        next_level_peers = peers[
            (peers['total_maturity'] > current_total * 1.15) & 
            (peers['total_maturity'] <= current_total * 1.30)
        ]
        
        if next_level_peers.empty:
            # Fallback: Just better peers
            next_level_peers = peers[peers['total_maturity'] > current_total]
            
        # Get Peer Question Averages (if any peers found)
        peer_q_avg = None
        if not next_level_peers.empty:
            peer_ids = next_level_peers.index
            # Intersect with available question data
            valid_pids = [p for p in peer_ids if p in self.question_data_train.index]
            if valid_pids:
                peer_q_avg = self.question_data_train.loc[valid_pids].mean()

        # 2. Initialize Roadmap
        roadmap = {
            'Phase 1: Foundation': [],
            'Phase 2: Implementation': [],
            'Phase 3: Scale & Governance': []
        }
        
        # Helps check for duplication
        added_themes = set()
        
        # 3. Add Mandatory Strategic Gaps
        for gap in strategic_gaps:
            # If gap has explicit theme/dim, map it
            d_name = gap.get('dimension_name')
            # If anomaly, it might have 'source_dim' or just title.
            # Parse from title if needed, or use 'source_dim' added in Analyze
            if not d_name and 'source_dim' in gap:
                d_name = gap['source_dim']
            
            # If still None (e.g. pure text anomaly?), try to infer or Default to P1
            if not d_name: 
                 # Try parse title
                 if ":" in gap['title']:
                     maybe_dim = gap['title'].split(":")[-1].split("vs")[0].strip() # rough heuristic
                     d_name = maybe_dim
            
            phase = PHASE_MAPPING.get(d_name, 'Phase 1: Foundation')
            
            # Construct item
            item_theme = gap.get('tactical_theme', f"Fix {d_name} Gaps")
            
            if item_theme not in added_themes:
                roadmap[phase].append({
                    "theme": item_theme,
                    "source": "Strategic Gap (Critical)",
                    "impact": gap['score'],
                    "dimension": d_name
                })
                added_themes.add(item_theme)

        # 4. Fill Empty Phases (Constraint: Every Phase must have content)
        # We need a candidate list of "Growth Opportunities" from the user's data
        # Prioritize by: Impact Score * (Peer Gap Bonus)
        
        candidates = []
        if not company_question_df.empty:
            for _, row in company_question_df.iterrows():
                theme = row.get('tactical_theme')
                if theme in added_themes: continue
                
                qid = row.get('question_id')
                user_score = row.get('score_1to5', 1)
                
                # Base Impact
                w = row.get('question_weight', 0)
                base_impact = w * (5.0 - user_score)
                
                # Peer Bonus
                peer_bonus = 1.0
                if peer_q_avg is not None and qid in peer_q_avg:
                    peer_score = peer_q_avg[qid]
                    if peer_score > user_score + 0.5: # Significant peer advantage
                        peer_bonus = 1.5
                
                candidates.append({
                    "theme": theme,
                    "dimension": row.get('dimension_name'),
                    "impact": base_impact * peer_bonus,
                    "final_score": base_impact * peer_bonus
                })
        
        # Sort candidates
        candidates.sort(key=lambda x: x['final_score'], reverse=True)
        
        # Fill logic
        phases = ['Phase 1: Foundation', 'Phase 2: Implementation', 'Phase 3: Scale & Governance']
        
        for phase in phases:
            if not roadmap[phase]:
                # Find best candidate for this phase
                found = None
                for c in candidates:
                    c_phase = PHASE_MAPPING.get(c['dimension'], 'Phase 1: Foundation')
                    if c_phase == phase and c['theme'] not in added_themes:
                        found = c
                        break
                
                if found:
                    roadmap[phase].append({
                        "theme": found['theme'],
                        "source": "Growth Opportunity",
                        "impact": found['final_score'],
                        "dimension": found['dimension']
                    })
                    added_themes.add(found['theme'])
                else:
                    # Fallback if no specific candidate fits the phase (rare, but possible if data is sparse)
                    # Force a generic item or pick next best regardless of mapping?
                    # Let's pick the next best available candidate and force it (Strategic necessity)
                    for c in candidates:
                        if c['theme'] not in added_themes:
                            roadmap[phase].append({
                                "theme": c['theme'],
                                "source": "Accelerated Growth", # Note distinct source
                                "impact": c['final_score'],
                                "dimension": c['dimension']
                            })
                            added_themes.add(c['theme'])
                            break

        return roadmap

    def synthesize_briefing(self, roadmap):
        """
        Synthesizes the textual 3-phase roadmap.
        """
        p1 = [i['theme'] for i in roadmap['Phase 1: Foundation']]
        p2 = [i['theme'] for i in roadmap['Phase 2: Implementation']]
        p3 = [i['theme'] for i in roadmap['Phase 3: Scale & Governance']]
        
        p1_text = ", ".join(p1) if p1 else "Foundation"
        p2_text = ", ".join(p2) if p2 else "Implementation"
        p3_text = ", ".join(p3) if p3 else "Optimization"
        
        briefing = f"""
### 🗺️ AI-Compass: Your 3-Phase Transformation Roadmap

To ensure a sustainable and high-ROI journey into AI, we recommend a phased approach that prioritizes foundational stability before complex technical scaling.

**Phase 1: Laying the Foundation**
Your first priority is **{p1_text}**. By focusing here, we ensure that your organizational data and culture are robust enough to support automation without creating friction.

**Phase 2: Targeted Implementation**
Once the foundation is secure, we move to **{p2_text}**. These areas have been identified as your highest-leverage opportunities, directly bridging the gap between your current status and the performance of industry leaders.

**Phase 3: Strategic Scaling**
The final phase focuses on **{p3_text}**. This is where we transition from single use-cases to an AI-driven operational model, ensuring long-term resilience and governance.

**Success Metric**: Completion of this roadmap will move your total maturity from its current level into the top 20% of your industry peer group.
"""
        return briefing

    def save_model(self, path_prefix):
        state = {
            'dim_data_train': self.dim_data_train,
            'question_data_train': self.question_data_train,
            'knn': self.knn,
            'scaler': self.scaler
        }
        with open(f"{path_prefix}_roadmap_gen.pkl", 'wb') as f:
            pickle.dump(state, f)

    def load_model(self, path_prefix):
        with open(f"{path_prefix}_roadmap_gen.pkl", 'rb') as f:
            state = pickle.load(f)
            self.dim_data_train = state['dim_data_train']
            self.question_data_train = state['question_data_train']
            self.knn = state['knn']
            self.scaler = state['scaler']
