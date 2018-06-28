`windows vc2010` 环境下编译 `cl /EHsc exception.cpp`，运行结果：

```c++
int __cdecl main(void) >> try
__thiscall CExceptionFail::CExceptionFail(const class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > &,class std::tr1::shared_ptr<class CRecordSuper>) >> ruby - use_count : 2
__thiscall CExceptionFail::CExceptionFail(const class CExceptionFail &) >> ruby - use_count : 2
__thiscall CExceptionFail::~CExceptionFail(void) >> ruby - use_count : 2
ruby - use_count : 1
__thiscall CExceptionFail::~CExceptionFail(void) >> andi - use_count : 1
int __cdecl main(void) >> end
```

`linux` 环境下编译 `g++ -std=c++11 exception.cpp`，运行结果：

```c++
int main() >> try
CExceptionFail::CExceptionFail(const string&, std::shared_ptr<CRecordSuper>) >> ruby - use_count : 2
ruby - use_count : 1
virtual CExceptionFail::~CExceptionFail() >> andi - use_count : 1
int main() >> end
```

`g++` 有一个编译参数 `-fno-elide-constructors` 可以关闭所有的有关 `copy constructor` 的优化，运行结果：

```c++
int main() >> try
CExceptionFail::CExceptionFail(const string&, std::shared_ptr<CRecordSuper>) >> ruby - use_count : 2
CExceptionFail::CExceptionFail(const CExceptionFail&) >> ruby - use_count : 3
virtual CExceptionFail::~CExceptionFail() >> ruby - use_count : 3
ruby - use_count : 1
virtual CExceptionFail::~CExceptionFail() >> andi - use_count : 1
int main() >> end
```
