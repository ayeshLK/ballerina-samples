// ballerina has first class support for XML
// xml is considered as sequences

string url = "http://sample.ballerina.com/home";
xml content = xml`<a href="${url}">Ballerina</a> is an <em>exciting</em> new language!`;
xml p = xml`<p>${content}</p>`;

xml x1 = xml`<p id="greeting">Hello World!</p>`;
string paraId = check x1.id;

xml:Element elem = xml`<p>Hello</p>`;

function stringToXml(string text) returns xml:Text {
    return xml:createText(text);
}

function rename(xml x, string oldName, string newName) {
    foreach xml:Element e in x.elements() {
        if (e.getName() == oldName) {
            e.setName(newName);
        }
        rename(e.getChildren(), oldName, newName);
    }
}

type Subject record {|
    string name;
    int credits;
|};

function subjectToXml(Subject[] subjects) returns xml {
    return xml`<data>${
        from var {name, credits} in subjects
        select xml`<subject name="${name}" credits="${credits}">${name}</subject>`
    }</data>`;
}
