#!/usr/bin/env python3
""" Log stats """
from pymongo import MongoClient

if __name__ == "__main__":
    client = MongoClient('mongodb://127.0.0.1:27017')
    db = client.logs
    coll = db['nginx']
    print(f'{coll.count_documents({})} logs\nMethods:\n')
    get = coll.count_documents({ 'method': 'GET' })
    post = coll.count_documents({ 'method': 'POST' })
    put = coll.count_documents({ 'method': 'PUT' })
    patch = coll.count_documents({ 'method': 'PATCH' })
    delete = coll.count_documents({ 'method': 'DELETE' })
    get_path = coll.count_documents({ 'method': 'GET', 'path': '/status'})
    method_count = {'GET': get, 'POST': post, 'PUT': put, 'PATCH': patch, 'DELETE': delete}
    for method, count in method_count.items():
        print(f'\tMethod {method}: {count}')
    print(f'{get_path} status check')

