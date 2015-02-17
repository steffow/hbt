if (Meteor.isClient) {
    Meteor.subscribe('books');
    var BooksCollection = new Meteor.Collection('books');

    Session.setDefault('counter', 0);

    Template.hello.helpers({
        book: function () {
            return BooksCollection.find().fetch();
        }
    });

    Template.hello.events({
        'click button': function () {
            // increment the counter when button is clicked
            Session.set('counter', Session.get('counter') + 1);
        }
    });
}

if (Meteor.isServer) {

    var BooksCollection = new Meteor.Collection('books', {
        idGeneration: 'MONGO'
    });
    
    Meteor.publish('books', function() {
        return BooksCollection.find();   
    })
    Meteor.startup(function () {
        // code to run on server at startup
    });


}