import asyncio
import sys
import os

# Add MVP_Chris to path
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(current_dir)

from core.services.response_service import calculate_response_metrics, ml_engine, csv_db

async def main():
    try:
        response_id = 504
        print(f"DEBUG: Checking Response {response_id}...")
        
        # 1. Check if it exists
        df = csv_db.read_table("responses")
        row = df[df['response_id'] == response_id]
        if row.empty:
            print("Response 504 NOT FOUND in CSV.")
            return

        print(f"Stored Data: {row.iloc[0].to_dict()}")

        # 2. Calculate Metrics
        dim_series, df_q, total_score = await calculate_response_metrics(response_id)
        
        if dim_series is None:
            print("Error: calculate_response_metrics returned None")
        else:
            print("\nCalculated Scores:")
            print(dim_series)
            print(f"Total Score: {total_score}")

            # 3. Run ML Analysis
            print("\nRunning ML Analysis...")
            analysis = ml_engine.run_analysis(dim_series, df_q)
            if "cluster" in analysis:
                print(f"ML Predicted Cluster: {analysis['cluster']}")
            else:
                print("ML Analysis did not return a cluster.")

    except Exception as e:
        print(f"Exception: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
