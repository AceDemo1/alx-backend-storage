#!/usr/bin/env python3
"""create cache class"""
import uuid
import redis
from typing import Union, Optional, Any


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

    def get(self, key: str, fn: Optional[Callable[bytes], Any] = None) -> Any:
        """get value"""
        value = self._redis.get(key)
        return fn(value) if fn else value

    def get_str(self, key: str) -> Optional[str]:
        """get_str"""
        return self.get(key, fn=lambda x: x.decode('utf-8'))

    def get_int(self, key: str) -> Optional[int]:
        """get_int"""
        return self.get(key, fn=int)
