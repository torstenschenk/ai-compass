import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../Application_Prototype/mvp_v1/backend")))

from database import SessionLocal
from models import ClusterProfile
import json

db = SessionLocal()
profiles = db.query(ClusterProfile).all()
print(f"Cluster Profiles in DB: {len(profiles)}")
for p in profiles:
    print(f"ID: {p.cluster_id}, Name: {p.cluster_name}")

if len(profiles) == 0:
    print("WARNING: cluster_profiles table is empty!")
