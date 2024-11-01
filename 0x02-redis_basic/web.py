#!/usr/bin/env python3
"""web cache and tracker"""
import requests
import redis
from typing import Callable, Any
import functools

r = redis.Redis()


def count(func: Callable) -> Callable:
    """count response"""
    @functools.wraps(func)
    def wrapper(url: str) -> Any:
        """wrapper func"""
        count_key = f'count:{url}'
        content_key = f'content:{url}'
        r.incr(count_key)
        cached = r.get(content_key)
        if cached:
            return cached.decode('utf-8')
        content = func(url)
        r.setex(content_key, 10, content)
        return content
    return wrapper


@count
def get_page(url: str) -> str:
    """obtain HTML content and returns it"""
    return requests.get(url).text
