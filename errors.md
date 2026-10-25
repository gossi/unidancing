utils.js:576 Missing onError handler and/or unhandled exception/promise rejection for invocation 'SpotifyMachine.authenticated.device.connecting:invocation[0]'. Original error: 'TypeError: connectPlayer is not a function'.  Stacktrace was 'TypeError: connectPlayer is not a function
    at connectPlayer (client.ts:33:19)
    at Interpreter._exec (interpreter.js:265:57)
    at Interpreter.exec (interpreter.js:1028:10)
    at Interpreter.execute (interpreter.js:383:14)
    at Interpreter.update (interpreter.js:411:12)
    at interpreter.js:106:15
    at Scheduler.process (scheduler.js:65:7)
    at Scheduler.schedule (scheduler.js:44:10)
    at Interpreter.send (interpreter.js:100:23)
    at StateBox.send (:4200/app/domain/supporting/statechart/index.ts:37:48)' Current error is 'TypeError: Cannot read properties of undefined (reading 'perform')'. Stacktrace was 'TypeError: Cannot read properties of undefined (reading 'perform':0:0)
    at loadDevices (client.ts:35:42)
    at Interpreter._exec (interpreter.js:265:57)
    at Interpreter.exec (interpreter.js:1028:10)
    at Interpreter.execute (interpreter.js:383:14)
    at Interpreter.update (interpreter.js:411:12)
    at interpreter.js:106:15
    at Scheduler.process (scheduler.js:65:7)
    at Scheduler.schedule (scheduler.js:44:10)
    at Interpreter.send (interpreter.js:100:23)
    at :4200/node_modules/.vite/deps/xstate.js?v=2728caae:2449:17':0:0
