# Invaders
## Execution
```
ruby app.rb
```

## Tests
```
rspec
```

## Customization
`Invaders::Services::Scanner` class accepts two optional arguments to customize the invader search algorithm:

`tolerance` 0.8 by default
A possible match will be consider as an invader if the found pattern matches in at least 80% with the original invader
`min_invader_size` 0.35 by default
A possible match will be consider as an invader if the found pattern has a size of at least the 35% of the invader

## Author
Adrián Fernández
