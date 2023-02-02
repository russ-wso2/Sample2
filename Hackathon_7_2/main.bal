// Introduce your solution here.
import projzone/webhook;
//import ballerina/websub;
import ballerina/io;

//import ballerina/http;

enum ACTION {
    opened,
    closed,
    commented, 
    labeled
}

enum VERSION {
    v1,
    v2
} 
enum KIND {
    bug,
    improvement,  
    feature_request = "feature request"
}
enum SEVERITY {
    high,
    medium,
    low    
}
enum IMPACT {
    low,
    significant
}
type DiscussionDetails record {|
    readonly string title ;
    string kind;
    string affectedVersion;
    int priority;
|};


type inputRecord record {
    KIND        kind;
    string      title;
    ACTION      action;
    string      actor;
    string      time;
    string[]    labels;
    VERSION     'version;
    string      content?;
    SEVERITY    severity?;
    string      new_label?;
    IMPACT      impact?;

    
};
configurable string secret = "sjdjglgggg";
table<DiscussionDetails> key (title) discussionDetails = table [];
configurable int port  = 8091;
configurable string hub = "http://localhost:9090/hub";
configurable string topic ="http://projzone.com/gofigure/Connectors/events/all.json";
configurable string orgName = "gofigure";
configurable string projName = "Connectors";
int inputCount = 0;
int savedCount = 0;

listener webhook:Listener ln = new (port, orgName, projName, secret, hub);

service webhook:BugDiscussionService on ln {
    remote function onDiscussionClosed(webhook:BugDiscussionEvent event) {
        // Implement necessary logic if it is required to perform
        // a certain action when a bug discussion is opened.

        io:println("in Bug/onDiscussionClosed", event);
        inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);


    }

    remote function onDiscussionCommented(webhook:BugDiscussionOpenedOrCommentedEvent event) {
        io:println("in Bug/onDiscussionCommented", event);
        inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);
    }

    remote function onDiscussionLabeled(webhook:BugDiscussionLabeledEvent event) {
        io:println("in Bug/onDiscussionLabeled", event);
        inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);

    }

    remote function onDiscussionOpened(webhook:BugDiscussionOpenedOrCommentedEvent event) {
        io:println("in Bug/onDiscussionOpened", event);
        inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);
        }

    
    // Defines the remote function that accepts the event notification request for the WebHook.
   
    }

service webhook:ImprovementDiscussionService on ln {
    remote function onDiscussionClosed(webhook:ImprovementDiscussionEvent event) {
        // Implement necessary logic if it is required to perform
        // a certain action when a bug discussion is opened.
        io:println("in Improvement/onDiscussionClosed", event);
        inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);

    }
    remote function onDiscussionCommented(webhook:ImprovementDiscussionOpenedOrCommentedEvent event) {
        io:println("in Improvement/onDiscussionCommented", event);
                inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);
    }
    remote function onDiscussionLabeled(webhook:ImprovementDiscussionLabeledEvent event) {
        io:println("in Improvement/onDiscussionLabeled", event);
        inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);


    }
    remote function onDiscussionOpened(webhook:ImprovementDiscussionOpenedOrCommentedEvent event) {
        io:println("in Improvement/onDiscussionOpened", event);
        inputRecord IR;
        do {    
            IR = check event.cloneWithType(inputRecord);
        }
        on fail error e {
            io:println("Error converting = ", e);
            return;
        }
        io:print("converted ", IR);
        inputCount +=1;
        string status = processInputRecord(IR);
        io:println("completed - status = ", status, 
            "input count = ", inputCount, " saved count ", savedCount);


    }

}


function processInputRecord(inputRecord IR) returns string { 
    boolean isDocumentation = false;
    int i= 0;
    foreach var item in IR.labels {
        i = i+1;
        io:println("count = ", i, " label = ", item);
        if item == "documentation" {
            isDocumentation = true;
            break;
        } 
    }
// delete the record if there
    DiscussionDetails? oldRec= discussionDetails[IR.title];

    if oldRec !=() {
        _ = discussionDetails.remove(IR.title);
        savedCount -=1;
        io:println("record removed ", oldRec);
    }
    if!isDocumentation {
        return "not documentation";
    }
    // now add
    if IR.action == closed || IR.action == commented {
        return "closed or commented";
    }
    DiscussionDetails DD = {title: IR.title, kind: IR.kind, 
    affectedVersion: IR.'version, priority: 0};
    if IR.kind == bug {
        if IR.severity == high {
            DD.priority = 1;
        }
        else if IR.severity == medium {
            DD.priority = 2;
        }
        else if IR.severity == low {
            DD.priority = 3;
        }
        else {
            string err = "invalid severity";
            io:println(err, " " , IR.severity);
            return err;
        }
    }  
    else if IR.kind == improvement {
        if  IR.impact ==  significant {
            DD.priority = 2;
        }
        else if IR.impact == low {
             DD.priority = 3;
        }
        else {
            string err = "invalid impact";
            io:println(err, " " , IR.impact);
            return err;
        }    
    } 
    else if IR.kind == feature_request {
        DD.priority = 3;
    }
    else {
        string err = "invalid kind";
            io:println(err, " " , IR.kind);
            return err;
    }
    do {
     discussionDetails.add(DD);
    }
    on fail error e {
        io:println("add failed ", e);
        return "failed";
    }
    savedCount +=1;
    io:println("added record ", DD);
    return "success";
}
