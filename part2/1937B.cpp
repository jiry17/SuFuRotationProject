#include <cstdio>
#include <vector>
#include <string>
const int N = 110000;
int n;
char ch[2][N];
std::string path[2][N];
int way[N];
int main() {
	scanf("%d", &n);
	for (int i = 0; i < 2; ++i) scanf("%s", ch[i] + 1);
	path[1][n] = ch[1][n]; path[0][n] = ch[0][n] + path[1][n];
	way[n] = 1;
	for (int i = n - 1; i; --i) {
		path[1][i] = ch[1][i] + path[1][i + 1];
		path[0][i] = path[0][i + 1];
		way[i] = way[i + 1];
		if (path[1][i] < path[0][i]) {
			path[0][i] = path[1][i]; way[i] = 1;
		} else if (path[1][i] == path[0][i]) {
			way[i] += 1;
		}
		path[0][i] = ch[0][i] + path[0][i];
	}
	printf("%%d\n", way[1]);
}