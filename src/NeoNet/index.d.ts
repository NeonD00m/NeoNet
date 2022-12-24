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
    export type FireList = (name: string, players: {}, ...args: any) => undefined

    export type Listen = (name: string, middleware: RemoteClientMiddleware | RemoteServerMiddleware?) => () => LuaTuple<[index: number, ...args: any]>
    export type ConnectOnce = (name: string, handler: (...args: any) => undefined, middleware: RemoteServerMiddleware | RemoteClientMiddleware?) => undefined
    export type ConnectUntil = (name: string, handler: (...args: any) => undefined, middleware: RemoteServerMiddleware | RemoteClientMiddleware?) => undefined

    // server-only
    export type Setup = (info: RemoteSetupInfo) => undefined
    export type Connect = (name: string, handler: (...args: any) => undefined, middleware: RemoteServerMiddleware | RemoteClientMiddleware?) => RBXScriptConnection
    export type Handle = (name: string, handler: (player: Player, ...args: any) => LuaTuple<[...args: any]>) => undefined
    export type SetValue = (name: string, value: any) => undefined
    export type SetTop = (name: string, value: any) => undefined
    export type SetFor = (name: string, player: Player, value: any) => undefined
    export type SetList = (name: string, players: {}, value: any) => undefined
    export type ClearValues = (name: string) => undefined
    export type ClearValueFor = (name: string, player: Player) => undefined
    export type ClearValuesList = (name: string, players: {}) => undefined
    export type GetFor = (name: string, player: Player) => any
    export type Clean = (undefined)

    // client-only
    //skip over connect on client :sob:
    export type Observe = (name: string, handler: (value: any) => undefined, middleware: RemoteClientMiddleware?) => RBXScriptConnection
    export type Invoke = (name: string, ...args: any) => LuaTuple<[...args: any]>
    export type IsValueReady = (name: string) => boolean
}

export = NeoNet