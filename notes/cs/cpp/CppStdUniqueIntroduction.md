# std::unique 介绍

## std::unique是线程安全的吗？

`std::unique_ptr`对并发访问并不是线程安全的。这意味着任何保证安全的源自多个线程的同时访问的内置同步机制都是不提供的。这和C++的标准库是一致的，它并不提供线程安全性。

以下是一些具体的原因:

1. **同时访问:** 如果一个线程在修改一个`std::unique_ptr`的同时（比如，reset或改变它管理的对象时），另外一个线程试图访问它（dereference，或检查是否为空），那么就会产生数据竞争，这会导致未定义行为。

2. **Ownership 语义:** The `std::unique_ptr` is designed to enforce unique ownership semantics, meaning that it assumes a single owner. As such, it isn't designed to handle the case where multiple threads might try to take ownership simultaneously or where ownership might need to be transferred between threads.

3. **No Synchronization Mechanism:** As mentioned earlier, `std::unique_ptr` doesn't contain any built-in synchronization mechanism like mutexes or atomic operations to ensure thread safety. This is by design, as adding such mechanisms would add overhead that isn't necessary in single-threaded contexts.

If you need to share a dynamically allocated object between multiple threads, consider using `std::shared_ptr` along with `std::mutex` or other synchronization primitives to ensure thread-safety. Alternatively, if the ownership of the `std::unique_ptr` needs to be transferred between threads, ensure that such transfers are done in a thread-safe manner (i.e., no two threads are accessing the `std::unique_ptr` simultaneously). 

Remember that even when using `std::shared_ptr`, only the control block (reference counts) is thread-safe, not the underlying object. You still need to synchronize access to the underlying object if it's being accessed from multiple threads.