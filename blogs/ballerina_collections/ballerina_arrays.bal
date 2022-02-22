string[] books = ["Harry Potter", "Angels & Demons"];
string bookOne = books[0];

int[] values1 = [1, 2, 3, 4, 5];
int[] values2 = [2, 4, 1, 5, 3];

// `isEqual` will be `false`
boolean isEqual = values1 == values2;

// reverse the order of the members of the array
string[] reverse = books.reverse();

int[] values = [80, 85, 90];
// combines the array values to one value
int total = values.reduce(function(int a, int b) returns int => a + b, 0);

int[] marks = [90, 50, 65, 80];
// filters the marks which are higher than `75`
int[] higherMarks = marks.filter(a => a >= 75);
