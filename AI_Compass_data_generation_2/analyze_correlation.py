import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Plot-Styling
sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (16, 14)

def run_analysis():
    print("Starte Korrelationsanalyse...")
    
    # 1. Daten laden
    try:
        df = pd.read_csv('assessment_data.csv')
        questions_df = pd.read_csv('Questions.csv', sep=';', skiprows=1)
        print("Daten geladen.")
    except FileNotFoundError:
        print("Fehler: 'assessment_data.csv' oder 'Questions.csv' nicht gefunden.")
        return

    # 2. Mapping Dictionary aufbauen
    mapping_dict = {}
    for idx, row in questions_df.iterrows():
        q_text = row['Question_Text']
        
        # Nur Slider, Statement und Choice Fragen
        if row['Question_Type'] in ['Slider', 'Statement', 'Choice']:
            q_map = {}
            for i in range(1, 10):
                col_name = f'Level {i}'
                val = row[col_name]
                if pd.notna(val):
                    val_clean = str(val).strip()
                    q_map[val_clean] = i
            
            if q_map:
                mapping_dict[q_text] = q_map

    print(f"{len(mapping_dict)} Fragen identifiziert.")

    # 3. Transformieren
    df_numeric = df.copy()
    numeric_cols = []

    for col, map_vals in mapping_dict.items():
        if col in df_numeric.columns:
            new_col_name = col[:30] + "..." 
            # Mapping anwenden
            df_numeric[new_col_name] = df_numeric[col].astype(str).str.strip().map(map_vals)
            numeric_cols.append(new_col_name)

    # 4. Korrelation berechnen
    if not numeric_cols:
        print("Keine numerischen Spalten gematcht.")
        return
        
    corr_data = df_numeric[numeric_cols]
    corr_matrix = corr_data.corr(method='spearman')

    # 5. Top-Korrelationen ausgeben
    print("\n--- Stärkste Korrelationen (Top 10 Positiv) ---")
    
    # Matrix in eine Serie umwandeln, Diagonale und Duplikate entfernen
    corr_pairs = corr_matrix.unstack()
    corr_pairs = corr_pairs[corr_pairs.index.get_level_values(0) != corr_pairs.index.get_level_values(1)]
    # Jedes Paar nur einmal (da symmetrisch)
    unique_pairs = corr_pairs.drop_duplicates()
    
    # Sortieren
    sorted_pairs = unique_pairs.sort_values(ascending=False)
    
    for i, (idx, val) in enumerate(sorted_pairs.head(10).items()):
        print(f"{i+1}. {idx[0]} <--> {idx[1]}: {val:.2f}")

    print("\n--- Stärkste Negative Korrelationen ---")
    sorted_pairs_neg = unique_pairs.sort_values(ascending=True)
    for i, (idx, val) in enumerate(sorted_pairs_neg.head(5).items()):
         print(f"{i+1}. {idx[0]} <--> {idx[1]}: {val:.2f}")

    # 6. Plotten
    plt.figure(figsize=(16, 14))
    sns.heatmap(corr_matrix, annot=False, cmap='coolwarm', vmin=-1, vmax=1)
    plt.title('Korrelationsmatrix der Antworten (Spearman)')
    plt.tight_layout()
    
    output_file = 'correlation_heatmap.png'
    plt.savefig(output_file)
    print(f"\nAnalyse fertig. Grafik gespeichert als: {output_file}")

if __name__ == "__main__":
    run_analysis()
