#!/usr/bin/env python3
"""web cache and tracker"""
import requests
import redis
from typing import Callable, Any
import functools

r = redis.Redis()

def count(func: Callable) -> Callable:
    """Count and cache response"""
    @functools.wraps(func)
    def wrapper(url: str) -> Any:
        count_key = f'count:{url}'
        content_key = f'content:{url}'
        
        # Increment the call count
        r.incr(count_key)
        
        # Check cache for existing content
        cached = r.get(content_key)
        if cached:
            return cached.decode('utf-8')
        
        # Fetch content and cache with a 10-second expiration
        content = func(url)
        r.setex(content_key, 10, content)
        return content
    
    return wrapper


@count
def get_page(url: str) -> str:
    """obtain HTML content and returns it"""
    return requests.get(url).text
