#!/usr/bin/env python3
"""create cache class"""
import uuid
import redis
from typing import Union


class Cache:
    def __init__(self):
        """initializes"""
        self._redis = redis.Redis()
        self._redis.flushdb()

    def store(self, data: Union[str, bytes, int, float]) -> str:
        """stores"""
        key = str(uuid.uuid4())
        self._redis.set(key, data)
        return key
