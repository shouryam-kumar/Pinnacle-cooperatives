import { Button, chakra, Image, Link } from '@chakra-ui/react'
import NextLink from "next/link"
import { Box } from "@chakra-ui/react"
import * as React from "react"
import '../public/LogoImg.svg'
import Logo from '../Components/Logo'


function Navbar(props) {

  return (
    <>
        <Box bg='red' w='100%' p={4} color='black' maxHeight='5rem'>
          <Box px={4} >
            <Button size='md' background='transparent' variant='ghost' colorScheme='whiteAlpha'>
              <NextLink href='./Test' passHref>
              <Link >
              <Image src='LogoImg.svg' boxSize='60px' border='1px' borderColor='black' borderRadius='3500px' alt='pinnacle logo'/>
              </Link>
              </NextLink>
            </Button>
          </Box>
        </Box>
    </>
  )
}

export default Navbar
