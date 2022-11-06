export default function test ({title}) {
    return (
        (title ? 
            <h1>This is testing prop : {title}</h1>
             : <h1>No props was supplied!</h1>
            )
        
        
    )
}