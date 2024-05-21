# 为什么要使得函数内部的抽象层级处于同一个层级

将一个函数的内部抽象级别保持在同一层级是一种称为"一致的抽象层次"的编程原则。这个原则是为了提高代码的可读性和可维护性。

当我们阅读一个函数的时候，如果函数的所有语句都在同一层次的抽象级别上，我们就可以更容易地理解这个函数的目的和行为。我们可以将函数看作是一种从其输入转换到其输出的抽象操作，而不需要关注具体的实现细节。

相反，如果一个函数的内部混合了多个抽象层次的语句，那么阅读和理解这个函数就会变得更困难。我们需要在不同的抽象层次之间跳跃，这会打断我们的思考流程，并可能导致理解错误。

此外，保持一致的抽象层次还有助于保持函数的粒度恰当。如果我们发现一个函数的内部有多个抽象层次的语句，那么这可能是一个信号，告诉我们这个函数正在做太多的事情，我们可能需要将其分解为多个更小的函数。

总的来说，保持函数内部的抽象级别一致是一种良好的编程实践，它可以帮助我们编写出更清晰、更易于理解和维护的代码。

## 一个简单描述抽象层级的例子

让我们以一个简化的例子来说明这个概念。假设我们有一个函数，它的任务是从网络上下载一个文件，然后处理这个文件。一个不太好的设计可能是将所有这些操作都放在一个函数中，如下所示：

```cpp
void downloadAndProcessFile(std::string url) {
    // 创建一个 HTTP 请求
    HttpRequest request(url);

    // 发送请求并获取响应
    HttpResponse response = request.send();

    // 检查响应状态码
    if (response.getStatusCode() != 200) {
        throw std::runtime_error("Failed to download file");
    }

    // 获取响应体
    std::string fileContents = response.getBody();

    // 进行一些处理
    for (char& c : fileContents) {
        c = std::toupper(c);
    }

    // 写入到一个文件中
    std::ofstream out("output.txt");
    out << fileContents;
}
```

这个函数的问题在于，它混合了多个抽象级别的操作：网络通信、错误处理、字符串处理和文件 I/O。这使得函数很难理解和维护。

相反，一个更好的设计可能是将这些操作分解到几个更小的函数中，每个函数都在同一层次的抽象级别上操作：

```cpp
std::string downloadFile(std::string url) {
    // 创建一个 HTTP 请求
    HttpRequest request(url);

    // 发送请求并获取响应
    HttpResponse response = request.send();

    // 检查响应状态码
    if (response.getStatusCode() != 200) {
        throw std::runtime_error("Failed to download file");
    }

    // 返回响应体
    return response.getBody();
}

std::string processContents(std::string contents) {
    // 对内容进行处理
    for (char& c : contents) {
        c = std::toupper(c);
    }

    return contents;
}

void writeToFile(std::string contents, std::string filename) {
    // 将内容写入文件
    std::ofstream out(filename);
    out << contents;
}

void downloadAndProcessFile(std::string url) {
    std::string fileContents = downloadFile(url);
    std::string processedContents = processContents(fileContents);
    writeToFile(processedContents, "output.txt");
}
```

在这个改进的设计中，`downloadAndProcessFile` 函数就像是一个故事的大纲，它描述了函数要做什么，而不是怎么做。
