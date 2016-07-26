node('php') {
    stage 'Checkout tests'
    git 'https://github.com/nasqueron/operations.git'

    stage 'Prod tests'
    dir('tests/prod-environment-behaves-correctly') {
        sh 'make test'
    }
}
