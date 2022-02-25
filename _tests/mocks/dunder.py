class dunder:
    def __init__(self):
        self.data = {}

    def get(self, key, default=None):
        if key in self.data:
            return self.data[key]

        return default

    def set(self, key, value):
        self.data[key] = value

    def __iter__(self):
        for key, value in self.data.items():
            yield [key, value]

    def __getitem__(self, key):
        if key not in self.data:
            raise KeyError

        return self.data[key]

    def __setitem__(self, key, value):
        self.data[key] = value
