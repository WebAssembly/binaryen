volatile int x, y;

__attribute__((constructor))
void init_x() {
    x = 14;
}

__attribute__((constructor))
void init_y() {
    y = 144;
}

int main() {
    return x + y;
}
