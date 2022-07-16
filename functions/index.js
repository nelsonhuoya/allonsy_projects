const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const stripe = require("stripe")("sk_test_51L9b1HHXlqIbO8KB6fYxdZ7mhfH4y3yqdWK9VLg6w3ruf8Ozl25wL20kMMADMaF6dUjEMNkzADjwo5C6LpvS9pbY00KCFxiyak");

//Payment

exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
    console.log('------------------- start new payment function ----------------------')
    try {
        let customerId;

        //Gets the customer who's email id matches the one sent by the client
        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });

        //Checks the if the customer exists, if not creates a new customer
        if (customerList.data.length !== 0) {
            customerId = customerList.data[0].id;
        }
        else {
            const customer = await stripe.customers.create({
                email: req.body.email
            });
            customerId = customer.id;
        }

        //Creates a temporary secret key linked with the customer
        const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2020-08-27' }
        );

        //Creates a new payment intent with amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(req.body.amount),
            currency: 'brl',
            customer: customerId,
        })

        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
            success: true,
        })

    } catch (error) {
        res.status(404).send({ success: false, error: error.message })
    }
});


//New order notification

exports.sendNewOrderNotification = functions.firestore
    .document('pedidos/{pedidosId}')
    .onCreate((snap, context) => {
    console.log('------------------- start new order function ----------------------')

    const newValue =  snap.data();

    const email = newValue.email;
    console.log(email);

    return admin.firestore().collection("users").doc("nelsonhouya@gmail.com")
                    .get()
                    .then(doc => {
                    const token = doc.data().token;
                    console.log(token);
                    const payload = {
                                notification:{
                                    title: 'Pedido Recebido',
                                    body: "Um novo pedido foi realizado",
                                    badge: "1",
                                    sound: "default"
                                }
                            }

                    admin.messaging().sendToDevice(
                            token,
                            payload).then(response => {
                                console.log("Successfully sent message:", response)
                                })
                                .catch(error => {
                                console.log('Error sending message:', error)
                                })

                    })
});

//Change Order Status Notification

exports.sendUpdateOrderNotification = functions.firestore
    .document('pedidos/{pedidosId}')
    .onUpdate((change, context) => {
    console.log('------------------- start change situation function ----------------------')

    const newValue = change.after.data();

    const situacao = newValue.situacao;
    console.log(situacao);

    const email = newValue.email;
    console.log(email);


    return admin.firestore().collection("users").doc(email)
        .get()
        .then(doc => {
        const token = doc.data().token;
        console.log(token);
        const payload = {
                    notification:{
                        title: situacao == 'Enviado'? "Pedido Enviado" : situacao == 'Entregue'? "Pedido Entregue" : "Pedido Cancelado",
                        body: situacao == 'Enviado'? "Seu pedido foi enviado e deve chegar em breve."
                        : situacao == 'Entregue'? "Seu pedido foi entregue. Bon Appétit." : "Pedimos desculpa mas seu pedido foi cancelado.",
                        badge: "1",
                        sound: "default"
                    }
                }

        admin.messaging().sendToDevice(
                token,
                payload).then(response => {
                    console.log("Successfully sent message:", response)
                    })
                    .catch(error => {
                    console.log('Error sending message:', error)
                    })

        })

});

//New Message Notification

exports.sendMessageNotification = functions.firestore
    .document('mensagens/{mensagensId}')
    .onUpdate((change, context) => {
    console.log('------------------- start new message function ----------------------')

    const newValue = change.after.data();

    const email = newValue.email;
    console.log(email);

    const usuariomsg = newValue.usuariomsg;
    console.log(usuariomsg)

    if(usuariomsg == "Allons-y"){
    return admin.firestore().collection("users").doc(email)
            .get()
            .then(doc => {
            const token = doc.data().token;
            console.log(token);
            const payload = {
                        notification:{
                            title: 'Nova mensagem do Allons-y',
                            body: "O restaurante Allons-y te respondeu.",
                            badge: "1",
                            sound: "default"
                        }
                    }

            admin.messaging().sendToDevice(
                    token,
                    payload).then(response => {
                        console.log("Successfully sent message:", response)
                        })
                        .catch(error => {
                        console.log('Error sending message:', error)
                        })

            })

    } else {

    return admin.firestore().collection("users").doc("nelsonhouya@gmail.com")
                .get()
                .then(doc => {
                const token = doc.data().token;
                console.log(token);
                const payload = {
                            notification:{
                                title: 'Nova mensagem do cliente',
                                body: "Um cliente enviou uma nova mensagem",
                                badge: "1",
                                sound: "default"
                            }
                        }

                admin.messaging().sendToDevice(
                        token,
                        payload).then(response => {
                            console.log("Successfully sent message:", response)
                            })
                            .catch(error => {
                            console.log('Error sending message:', error)
                            })

                })
    }
});

//Communication Notification

exports.sendCommunicationNotification = functions.firestore
    .document('notificacao/{mensagensId}')
    .onCreate((snap, context) => {
    console.log('------------------- start new message function ----------------------')

    const notificacao = snap.data();

    const payload = {
          notification: {
            title: notificacao.title,
            body: notificacao.description,
            image: notificacao.image,
          },
        };

    return admin.messaging().sendToTopic('users',payload)
        .then(response => {
            console.log("Successfully sent message:", response)
            })
            .catch(error => {
            console.log('Error sending message:', error)
            })

});