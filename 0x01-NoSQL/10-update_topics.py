#!/usr/bin/env python3
"""update new docs"""

def update_topics(mongo_collection, name, topics):
    """define func"""
    mongo_collection.update_many({ 'name': name }, { '$set': { 'topics': topics }})
