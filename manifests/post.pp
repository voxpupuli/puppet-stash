# == Class: stash::post
#
class stash::post {

  postgresql_psql { 'server.id':
    command => "update app_property set prop_value = 'BPIA-X1C2-6W65-NU7D' where prop_key = 'server.id'",
    db      => 'stash',
  }

  postgresql_psql { 'license':
    command => "insert into app_property set prop_value = 'AAABHg0ODAoPeNptkMFqg0AQhu/7FAM9b8lqYjCwh0QtFdSEatoeetlup8lSXWV3Dc3bV2MgUHKYw8x8fPMzD2WvocQO2ByYv/LDlb+EKK7Am7E5idFKozqnWs1LJ+wR9rpWjXL4BXuLxn6sIDmJuhcjApmSqC2SyOBlEAuHfBTRWUjZgtxQ7kyPxI7KRyGdOuE0qSfD66AeKY/kQmmHWmiJyW+nzPnmZLPRuTUHoZWdrE/KWAfFpRE1bIT+AQrP7YBAhfKo27o9nK93r2mrc4eFaJBH2zxPXqJ0nZESzQlNGvPNLl3TdxZ5NHgLFrTYL2NSJgUfimbzxTIMfI9cRQOepfG9zf3kU4qibz7RbL8v7+SUkV1v5FFY/P+8PyQniXgwLQIUTkRzCztmVummuuq+d7MxDWdw4tICFQCQ/Fl6BEOoDCTXrrvODO2aOgWsqQ==X02ei' where prop_key = 'license';",
    db      => 'stash',
  }

}
