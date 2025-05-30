# Turms discovery

> Self-hostable discovery system for Turms.

## Self-host

Discovery system may be self-hostable. However, a version managed by [Gravitalia](https://www.gravitalia.com/) is publicy available with Gravitalia accounts.

1. `git clone https://github.com/TurmsApp/discovery.git`
2. `mix ecto.migrate`
3. `mix phx.server`

> [!WARNING]  
> Using self-hosting doesn't allow you to be randomly discovered **OR** to be publicly visible.
> Your friends will need to specify the domain such as `<username>@<sld>.<tld>` (e.g.: `me@example.com`) instead of your simple Gravitalia username.
