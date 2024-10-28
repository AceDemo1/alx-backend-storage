#!/usr/bin/env python3
""" pymongo module """


def top_students(mongo_collection):
    """ Returns all students sorted by average score """
    docs = mongo_collection.find()
    res = []
    for stu in docs:
        [score for stu.topics

    return results
