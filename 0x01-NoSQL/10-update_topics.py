#!/usr/bin/env python3
"""insert new docs"""

def update_topics(mongo_collection, name, topics):
    """define func"""
    mongo_collection.update({ name: name }, { $set { 'topics': topics }})
