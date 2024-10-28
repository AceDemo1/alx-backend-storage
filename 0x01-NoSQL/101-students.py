#!/usr/bin/env python3
""" pymongo module """


def top_students(mongo_collection):
    """ Returns all students sorted by average score """
    docs = mongo_collection.find()
    res = []
    for stu in docs:
        scores = [i.get('score', 0) for i in stu.get('topics', [])]
        avg = sum(scores) / len(scores) if scores else 0
        student = stu.copy()
        student['averageScore'] = avg
        res.append(student)
    res.sort(key=lambda x: x['averageScore'], reverse=True)
    return res
