import lists

var list = initSinglyLinkedList[int]()

list.prepend(123)
list.prepend(456)

var temp = list

list.prepend(789)
temp.prepend(list.head)

echo temp