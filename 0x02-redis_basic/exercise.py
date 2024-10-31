#!/usr/bin/env python3
"""create cache class"""
import uuid
import redis
from typing import Union, Optional, Any, Callable
import functools


def count_calls(method: Callable) -> Callable:
    """count method"""
    @functools.wraps(method)
    def wapper(self, *args, **kwargs):
        """wraps around the original method"""
        self._redis.incr(method.__qualname__)
        return method(self, *args, **kwargs)
    return wapper

def call_history(method: Callable) -> Callable:
    """history"""
    @functools.wraps(method)
    def wapper(self, *args, **kwargs):
        """wraps around the original method"""
        in_key = f'{method.__gualname}:inputs'
        out_key = f'{method.__gualname}:inputs'
        out = method(self, *args, **kwargs)
        self._redis.rpush(in_key, str(args))
        self._redis.rpush(out_key, str(out))
        return out
    return wapper

class Cache:
    def __init__(self):
        """initializes"""
        self._redis = redis.Redis()
        self._redis.flushdb()
    
    @call_history
    @count_calls
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """stores"""
        key = str(uuid.uuid4())
        self._redis.set(key, data)
        return key

    def get(self, key: str, fn: Optional[Callable[[bytes], Any]] = None) -> Any:
        """get value"""
        value = self._redis.get(key)
        return fn(value) if fn else value

    def get_str(self, key: str) -> Optional[str]:
        """get_str"""
        return self.get(key, fn=lambda x: x.decode('utf-8'))

    def get_int(self, key: str) -> Optional[int]:
        """get_int"""
        val = self.get(key)
        try:
            return int(val) if val is not None else None
        except:
            return 0


