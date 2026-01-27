import { useState, type ImgHTMLAttributes } from 'react';

interface ImageWithFallbackProps extends ImgHTMLAttributes<HTMLImageElement> {
    fallbackSrc?: string;
}

export function ImageWithFallback({
    src,
    fallbackSrc = 'https://via.placeholder.com/600x400?text=Image+Not+Found',
    alt,
    ...props
}: ImageWithFallbackProps) {
    const [imgSrc, setImgSrc] = useState(src);

    return (
        <img
            {...props}
            src={imgSrc}
            alt={alt}
            onError={() => setImgSrc(fallbackSrc)}
        />
    );
}
