

def string_checksum(string: str) -> int:
    """
    Function that compute checksum of string message.

    :param: string
    :return: checksum
    """
    checksum = 0
    for c in bytearray(string.encode()):
        checksum ^= c

    return checksum


def _decommenter(line: str) -> str:
    """
    Function that delete comment from G-code line.

    :param: line
    :return: string without comment
    """
    if line.find(';') == -1:
        return line

    else:
        return line[:line.index(';')]

