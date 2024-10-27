#!/usr/bin/env python3
"""insert new docs"""

def insert_school(mongo_collection, **kwargs):
    """define func"""
    return mongo_collection.insert_one(kwargs)
