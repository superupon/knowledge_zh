# std::all_of 算法

当然！下面是一个使用 `std::all_of` 算法的简单示例：

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int main() {
    std::vector<int> numbers = {2, 4, 6, 8, 10};

    // 使用 std::all_of 检查是否所有元素都是偶数
    bool allEven = std::all_of(numbers.begin(), numbers.end(), [](int num) {
        return num % 2 == 0;
    });

    if (allEven) {
        std::cout << "所有元素都是偶数" << std::endl;
    } else {
        std::cout << "存在非偶数元素" << std::endl;
    }

    return 0;
}
```

在上面的示例中，我们创建了一个 `std::vector` 容器 `numbers`，其中包含一些整数。然后，我们使用 `std::all_of` 算法来检查 `numbers` 容器中的所有元素是否都是偶数。通过传递一个 lambda 函数作为第三个参数，该函数检查给定的数是否为偶数（`num % 2 == 0`）。最后，我们根据检查结果输出相应的信息。

运行上述代码，将会得到以下输出：

```bash
所有元素都是偶数
```

因为 `numbers` 容器中的所有元素都是偶数，所以 `std::all_of` 返回 `true`，我们输出了相应的结果。
