# Flamework Template

A multiplace [roblox-ts](https://roblox-ts.com) template built on [Flamework](https://fireboltofdeath.dev/docs/flamework/).

Inspired by Roblox-Duck-Studios's [multiplace-template](https://github.com/Roblox-Duck-Studios/multiplace-template).

## Getting started

Install the toolchain with [Rokit](https://github.com/rojo-rbx/rokit) (Rojo, Lune, Darklua, Asphalt, rbxcloud), then the packages:

```console
rokit install
bun install
```

Compile and sync with Studio:

```console
bun watch:base   # rbxtsc in watch mode
bun rojo:base    # rojo serve
```

## Layout

| Path                    | Purpose                                                                  |
| ----------------------- | ------------------------------------------------------------------------ |
| `places/common`         | Code shared by every place: services, controllers, UI, store, remotes.   |
| `places/base`           | A place. Wires up Flamework and adds place specific code on top of common. |
| `store/<place>`         | Non-code instances (maps, models) extracted from the place file.         |

To add a place, copy `places/base`, adjust the paths in its `*.project.json` and add `compile:`, `build:` and `prod:` scripts.

Each place registers the common folders in `runtime.server.ts` / `runtime.client.ts` through `Flamework.addPaths`.
Anything placed in the `services`, `controllers`, `components`, `hooks` or `deps` folders is loaded automatically.

### Hooks

`common/server/hooks` (and `common/client/hooks`) hold lifecycle events such as `OnPlayerJoin`, `OnPlayerLeave` and `OnPlayerClick`.
Implement the interface in any service to receive the event:

```ts
@Service({})
export class MyService implements OnPlayerJoin {
	onPlayerJoin(player: Player) {}
}
```

### State

Player state lives in [Reflex](https://littensy.github.io/reflex/) slices under `common/shared/store` and is replicated to clients by the broadcaster.
Clients only receive **their own** data; loosen `beforeDispatch` / `beforeHydrate` in `common/server/store/middleware/broadcaster.ts` if you need to share more (e.g. for a leaderboard).

Saved data is defined by `PlayerSave` (`common/types/player-data.d.ts`) and the defaults in `common/server/constants/default-player-data.ts`.
Saving is disabled in Studio and in unpublished places; see `PLAYER_DATA_SAVING` in `common/shared/constants/flags.ts`.

### Flags

`common/shared/constants/flags.ts` holds the feature toggles, for example `FORCE_R6` to spawn every player as R6.

## Testing

Tests use [TestEZ](https://roblox.github.io/testez/) and run headlessly through [Lune](https://lune-org.github.io/docs).
Put specs in a `__tests__` folder next to the code they cover and name them `*.spec.ts`:

```ts
/// <reference types="@rbxts/testez/globals" />

export = () => {
	it("works", () => {
		expect(1 + 1).to.equal(2);
	});
};
```

```console
bun test:base
```

Server and client suites run against the built place; shared specs (`common/src/shared/__tests__`) run on both.

## Scripts

| Script                           | Description                                                     |
| -------------------------------- | --------------------------------------------------------------- |
| `bun compile:base`               | Compile with rbxtsc and minify into `dist` with Darklua.        |
| `bun build:base` / `prod:base`   | Build the development / production place file.                  |
| `bun extract:base`               | Extract Workspace, ReplicatedStorage and ServerStorage models into `store/`. Runs on commit. |
| `bun lint` / `bun fix`           | Lint / auto-fix. CI runs `bun eslint`, which fails on warnings. |
| `bun img:studio`                 | Upload assets with Asphalt.                                     |

## Deployment

Pushes to `main` lint, build the production place and publish it with rbxcloud.
Set the repository variables `UNIVERSE` and `PLACE` and the secret `RBX_CLOUD` (an Open Cloud API key).
