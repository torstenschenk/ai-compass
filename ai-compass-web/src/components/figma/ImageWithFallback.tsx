'use client';

import { useState } from 'react';
import Image, { ImageProps } from 'next/image';

interface ImageWithFallbackProps extends Omit<ImageProps, 'src'> {
    src: string;
    fallbackSrc?: string;
}

export function ImageWithFallback({
    src,
    fallbackSrc = 'https://images.unsplash.com/photo-1697577418970-95d99b5a55cf?q=80&w=1080',
    alt,
    ...props
}: ImageWithFallbackProps) {
    const [imgSrc, setImgSrc] = useState(src);

    return (
        <Image
            {...props}
            src={imgSrc}
            alt={alt}
            onError={() => setImgSrc(fallbackSrc)}
            width={600}
            height={400}
        />
    );
}
