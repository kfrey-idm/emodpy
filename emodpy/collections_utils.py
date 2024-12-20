from typing import Tuple, List, Mapping, Union, Iterable

from more_itertools import take


def cut_iterable_to(obj: Iterable, to: int) -> Tuple[Union[List, Mapping], int]:
    """
       Cut an iterable to a certain length.

    Args:
        obj: The iterable to cut.
        to: The number of elements to return.

    Returns:
        A list or dictionary (depending on the type of object) of elements and
        the remaining elements in the original list or dictionary.
    """
    if isinstance(obj, dict):
        slice = {k: v for (k, v) in take(to, obj.items())}
    else:
        slice = take(to, obj)

    remaining = len(obj) - to
    remaining = 0 if remaining < 0 else remaining
    return slice, remaining


####
# DicDeep v2
# https://github.com/mbello/dict-deep/blob/master/dict_deep/dict_deep.py
def deep_get(d, key, default: callable = None, getter: callable = None, sep: str = '.'):
    getter = __getter(getter, default)
    keys = __keys(key, sep)

    for k in keys:
        d = getter(d, k)

    return d


def deep_set(d, key, value, default: callable = None, getter: callable = None, setter: callable = None, sep: str = '.'):
    keys = __keys(key, sep)
    getter = __getter(getter, default)
    setter = __setter(setter)

    for i in range(len(keys) - 1):
        d = getter(d, keys[i])

    setter(d, keys[-1], value)


def deep_del(d: dict, key, getter: callable = None, deleter: callable = None, sep: str = '.'):
    keys = __keys(key, sep)
    getter = getter if getter is not None else lambda o, k: o.get(k)

    for i in range(len(keys) - 1):
        if d is None:
            return False, None
        d = getter(d, keys[i])

    if d is not None and isinstance(d, dict) and keys[-1] in d:
        retval = getter(d, keys[-1])
        if deleter is None:
            del d[keys[-1]]
        else:
            deleter(d, keys[-1])
        return True, retval
    else:
        return False, None


def __keys(key, sep: str):
    if isinstance(key, str):
        return key.split(sep=sep)
    else:
        return list(key)


def __getter(getter: callable, default: callable):
    if getter is not None:
        return getter
    elif default is not None:
        return lambda o, k: o.setdefault(k, default())
    else:
        return lambda o, k: o[k]


def __setter(setter: callable):
    def __default_setter(o, k, v):
        o[k] = v

    return setter if setter is not None else __default_setter
