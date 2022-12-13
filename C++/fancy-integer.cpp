#include <iostream>

using std::cout, std::endl;

class FancyInteger {
private:
    // pointer - this class uses heap memory!
    // int* could also mean int array, but for this class,
    // it's just gonna mean a single fancy int on the heap.
    int* theInt;
public:
    FancyInteger(int n) {
        this->theInt = new int{n};
    }
    ~FancyInteger() {
        // Destructor (rule 1 of 3)
        // delete our int
        delete this->theInt;
    }
    FancyInteger(FancyInteger& other) {
      // Copy constructor (rule 2 of 3)
        int othersInt = other.getValue();
        this->theInt = new int{othersInt};
    }
    FancyInteger& operator=(FancyInteger& other) {
        // Copy assignment operator (rule 3 of 3)
        // check for self-assignment operator, not sure if
        // this is needed for copy, but I'd put it just in case
        // (it's definitely needed for move constructor)
        if (this == &other) {
            // this pointer is same as address of other,
            // i.e. self-assignment (like x = x;)
            return *this;
        }

        // first delete our allocated memory
        delete this->theInt;
        // get the other one's value
        int othersInt = other.getValue();
        this->theInt = new int{othersInt};
        // same data, different pointers/heap memory locations
        
        // return reference to this object
        return *this;
    }
    int getValue() {
        // (getter)
        return *this->theInt;
    }

    int* getValueAddr() {
        return this->theInt;
    }
};

int main() {
    // Normal constructor
    FancyInteger fancyInt{1337};

    // Copy constructor (rule 2 of 3)
    FancyInteger fancyIntCopy{fancyInt};

    cout << fancyInt.getValue() << endl;
    cout << fancyInt.getValueAddr() << endl;
    cout << fancyIntCopy.getValue() << endl;
    cout << fancyIntCopy.getValueAddr() << endl;

    FancyInteger anotherOne{5555};
    cout << anotherOne.getValue() << endl;
    cout << anotherOne.getValueAddr() << endl;

    // Copy assignment operator (rule 3 of 3)
    fancyInt = anotherOne;
    // memory with 5555 deallocated; int* in fancyInt now points
    // to another region of memory with 1337 in it
    cout << anotherOne.getValue() << endl;
    cout << anotherOne.getValueAddr() << endl;

    // Destructor called when object is about to be unloaded (rule 1 of 3)
    return 0;
}