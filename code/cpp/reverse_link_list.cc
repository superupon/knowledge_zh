#include <iostream>

typedef struct LinkList{
  LinkList *next;
  int value;
} LinkList;

LinkList *reverseList(LinkList *list) {
  if (!list)
    return nullptr;
  LinkList *cur = list;
  LinkList *next = cur->next;
  LinkList *nnext = nullptr;
  cur->next = nullptr;
  while (next->next) {
    nnext = next->next;
    next->next = cur;
    cur = next;
    next = nnext;
  }
  next->next = cur;
  return next;
}

void printList(LinkList* list) {
   LinkList* cur = list;
   while(cur)  {
        std::cout << "list val: " << cur->value << std::endl;
        cur = cur->next;
   }    
}

int main() {
   LinkList* test = new LinkList();
   test->value = 10;
   LinkList* a = new LinkList();
   a->value = 12;
   test->next = a;
   printList(test);
   test = reverseList(test);
   printList(test);
   return 0;
}