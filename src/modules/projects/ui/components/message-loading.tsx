import Image from "next/image";
import { useState, useEffect } from "react";

const ShimmerMessages = () => {
  const messages = [
    "Suy nghĩ...",
    "Đang tải...",
    "Tạo ra...",
    "Phân tích yêu cầu của bạn...",
    "Xây dựng trang web của bạn...",
    "Thủ công thành phần...",
    "Tối ưu hóa bố cục...",
    "Thêm điểm nhấn cuối cùng...",
    "Gần như đã sẵn sàng...",
  ];

  const [currentMessageIndex, setCurrentMessageIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentMessageIndex((prev) => (prev + 1) % messages.length);
    }, 2000);

    return () => clearInterval(interval);
  }, [messages.length]);

  return (
    <div className="flex items-center gap-2">
      <span className="text-base text-muted-foreground animate-pulse">
        {messages[currentMessageIndex]}
      </span>
    </div>
  );
};

export const MessageLoading = () => {
  return (
    <div className="flex flex-col group px-2 pb-4">
      <div className="flex items-center gap-2 pl-2 mb-2">
        <Image
          src="/logo.svg"
          alt="Vibe"
          width={18}
          height={18}
          className="shrink-0"
        />
        <span className="text-sm font-medium">Vibe</span>
      </div>
      <div className="pl-8.5 flex flex-col gap-y-4">
        <ShimmerMessages />
      </div>
    </div>
  );
};
