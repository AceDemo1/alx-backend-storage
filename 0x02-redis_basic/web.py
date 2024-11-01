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

# URL with a 5-second delay
url = "http://slowwly.robertomurray.co.uk/delay/5000/url/http://example.com"
# Clear any existing Redis keys for a fresh test
r.delete(f"count:{url}", f"content:{url}")

# First call - should take 5 seconds
print("Fetching URL (first call, should be slow)...")
print(get_page(url))  # This call will be delayed due to the slow response simulation

# Check the count after the first call
print("Access count after first call:", int(r.get(f"count:{url}").decode('utf-8')))  # Expected: 1

# Second call - should be fast due to caching
print("Fetching URL again (second call, should be fast)...")
print(get_page(url))  # This should be quick if cached properly

# Check the count after the second call
print("Access count after second call:", int(r.get(f"count:{url}").decode('utf-8')))  # Expected: 2

