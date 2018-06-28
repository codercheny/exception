#include <iostream>
#include <memory>
#include <string>

using std::cout;
using std::endl;

#if !defined(__GNUC__)
#   define  __PRETTY_FUNCTION__ __FUNCSIG__
#endif

class CRecordSuper {
public:
    virtual ~CRecordSuper() {}
};

class CExceptionBase {
public:
    CExceptionBase(const std::string & name, std::shared_ptr<CRecordSuper> record) 
            : m_name(name), m_record(record) {}
    virtual ~CExceptionBase() {}

private:
    friend std::ostream & operator<<(std::ostream & o, CExceptionBase & ex);

public:
    void name(const std::string & name) { m_name = name; }

private:
    std::string m_name;
    std::shared_ptr<CRecordSuper> m_record;
};

std::ostream & operator<<(std::ostream & o, CExceptionBase & ex) {
    return o << ex.m_name << " - use_count : " << ex.m_record.use_count();
}

class CExceptionFail : public CExceptionBase {
public:
    CExceptionFail(const std::string & name, std::shared_ptr<CRecordSuper> record) 
            : CExceptionBase(name, record) {
        cout << __PRETTY_FUNCTION__ << " >> " << *this << endl;
    }
    virtual ~CExceptionFail() {
        cout << __PRETTY_FUNCTION__ << " >> " << *this << endl;
    }
    CExceptionFail(const CExceptionFail & obj) : CExceptionBase(obj) {
        cout << __PRETTY_FUNCTION__ << " >> " << *this << endl;
    }
};

int main()
{
    //CExceptionFail ex("ruby", std::make_shared<CRecordSuper>());

    try {
        cout << __PRETTY_FUNCTION__ << " >> try" << endl;
        throw CExceptionFail("ruby", std::make_shared<CRecordSuper>());
        //throw ex;
    } catch (CExceptionFail & _ex) {
        cout << _ex << endl;
        _ex.name("andi");
    } catch (CExceptionBase & _ex) { cout << _ex << endl; }

    //cout << ex << endl;
    cout << __PRETTY_FUNCTION__ << " >> end" << endl;

    return 0;
}
