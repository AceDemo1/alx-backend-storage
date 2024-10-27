#!/usr/bin/env python3
"""list docs"""

def list_all(mongo_collection):
    """define func"""
    return list(mongo_collection.find())
