#!/usr/bin/env python3
""" Log stats """
from pymongo import MongoClient

if __name__ == "__main__":
    client = MongoClient('mongodb://127.0.0.1:27017')
    db = client.logs
    coll = db['nginx']
    docs = coll.find()
    print(f'{len(list(docs))} logs\nMethods:\n')
    get = len(list( coll.find({ 'method': 'GET' })))
    post = len(list( coll.find({ 'method': 'POST' })))
    put = len(list( coll.find({ 'method': 'PUT' })))
    patch = len(list( coll.find({ 'method': 'PATCH' })))
    delete = len(list( coll.find({ 'method': 'DELETE' })))
    get_path = len(list( coll.find({ 'method': 'GET', 'path': '/status'})))
    method_count = {'GET': get, 'POST': post, ' PUT': put, 'PATCH': patch, 'DELETE': delete}
    for method, count in method_count.items():
        print(f'\tMethod {method}: {count}')
    print(f'{get_path} status check')

