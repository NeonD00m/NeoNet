type RemoteSetupInfo = {
    RemoteEvents: {number: string} | undefined,
    RemoteFunctions: {number: string} | undefined,
    RemoteValues: {string: any} | undefined,
};

type RemoteClientMiddleware = (
    Parameters: {number: any} | undefined
) => LuaTuple<[result: boolean, parameters: {number: any} | undefined]>;

type RemoteServerMiddleware = (
    player: Player,
    Parameters: {number: any} | undefined
) => LuaTuple<[result: boolean, parameters: {number: any} | undefined]>;

// NeoNet type
declare namespace NeoNet {
    export type UseParent = (parent: Instance) => undefined
    export type RemoteEvent = (name: string) => RemoteEvent
    export type RemoteFunction = (name: string) => RemoteFunction
    export type RemoteValue<T> = (name: string, value: T) => {Event: RemoteEvent, Value: T}

    export type GetValue = (name: string) => any
    export type Fire = (name: string, ...args: any) => undefined
    export type FireFor = (name: string, player: Player, ...args: any) => undefined
    export type FireExcept = (name: string, player: Player, ...args: any) => undefined
    export type FireList = (name: string, players: {Player}, ...args: any) => undefined


    // server-only
    export type Setup = (info: RemoteSetupInfo) => undefined
    export type Connect = (name: string, handler: (...args: any) => undefined, middleware: RemoteServerMiddleware) => RBXScriptConnection
    export type Handle = (name: string, handler: (player: Player, ...args: any) => LuaTuple<[...args: any]>) => undefined
    export type SetValue = (name: string, value: any) => undefined
    export type Clean = (undefined)

    // client-only
    //skip over connect on client :sob:
    export type Observe = (name: string, handler: (value: any) => undefined, middleware: RemoteClientMiddleware) => RBXScriptConnection
    export type Invoke = (name: string, ...args: any) => LuaTuple<[...args: any]>
}

export = NeoNet