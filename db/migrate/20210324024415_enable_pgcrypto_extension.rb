class EnablePgcryptoExtension < ActiveRecord::Migration[6.1]
  def change
    execute 'CREATE SCHEMA IF NOT EXISTS shared_extensions;'
    execute 'CREATE EXTENSION IF NOT EXISTS HSTORE SCHEMA shared_extensions;'
    execute 'CREATE EXTENSION IF NOT EXISTS "pgcrypto" SCHEMA shared_extensions;'
    execute 'GRANT usage ON SCHEMA shared_extensions to public;'
  end
end
