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
        in_key = f'{method.__qualname__}:inputs'
        out_key = f'{method.__qualname__}:outputs'
        out = method(self, *args, **kwargs)
        self._redis.rpush(in_key, str(args))
        self._redis.rpush(out_key, str(out))
        return out
    return wapper


def replay(method: Callable):
    """display history of calls"""
    func_name = method.__qualname__
    in_key = f'{method.__qualname__}:inputs'
    out_key = f'{method.__qualname__}:outputs'
    inputs = method.__self__._redis.lrange(in_key, 0, -1)
    outputs = method.__self__._redis.lrange(out_key, 0, -1)
    print(f"{func_name} was called {len(inputs)} times:")
    for i, j in zip(inputs, outputs):
        print(f"{func_name}(*{i.decode('utf-8')}) -> {j.decode('utf-8')}")


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
        except Exception:
            return 0
