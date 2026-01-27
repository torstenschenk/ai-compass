import asyncio
import sys
import os

# Add MVP_Chris to path
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(current_dir)

from core.services.response_service import calculate_response_metrics

async def main():
    try:
        print("Calculating metrics for response 500...")
        dim_series, df, total_score = await calculate_response_metrics(500)
        
        if dim_series is None:
            print("Error: dim_series is None")
        else:
            print("Dimension Scores:")
            print(dim_series)
            print(f"Total Score: {total_score}")
            
            # Check if all are 1.0 (failure case) or varied
            # Note: It's possible for a real score to be 1.0, but unlikely all of them.
            # Response 500 has many answers, so scores should be > 1.0.
            scores = list(dim_series.values)
            if all(s == 1.0 for s in scores):
                print("FAILURE: All scores are 1.0")
            else:
                print("SUCCESS: Scores are varied")
                
    except Exception as e:
        print(f"Exception: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
