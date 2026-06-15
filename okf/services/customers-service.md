---
type: Service
title: Customers Service
description: Customer profiles, accounts, and communication preferences.
resource: https://github.com/org/customers-service
tags: [customers, identity, .net]
---

## Responsibility

Manages customer identity, profiles, addresses, and communication preferences.

## Publishes

None currently.

## Subscribes To

None currently.

## API

- `GET /api/customers/{id}` — Get customer profile
- `PUT /api/customers/{id}` — Update profile
- `GET /api/customers/{id}/preferences` — Get communication preferences

## Data

Customers, Addresses, Preferences
